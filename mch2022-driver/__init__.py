import mch22
import buttons
import display

def op_split(path):
	if path == "":
		return ("", "")
	r = path.rsplit("/", 1)
	if len(r) == 1:
		return ("", path)
	head = r[0]
	if not head:
		head = "/"
	return (head, r[1])

def getcwd():
	return op_split(__file__)[0]

def level_button(level, selected):
	# white if selected, green otherwise
	color = 0xFFFFFF if selected else 0x00FF00
	y = (level - 1) * 30
	display.drawRect(0, y, 80, 24, True, 0x0000FF)
	text = "level " + str(level) if level < 8 else "Quit"
	display.drawText(5, y, text, color, "dejavusans20")


def level_buttons():
	global g_level

	display.drawFill(0x000000)
	for lvl in range(1, 9):
		level_button(lvl, lvl == g_level)
	display.flush()

# buttons
g_btn_state = 0
g_level = 1
g_playing = False

def button_report(btn_mask, pressed):
	global g_btn_state
	global g_playing

	if g_playing:
		if pressed:
			g_btn_state |= btn_mask
		else:
			g_btn_state &= ~btn_mask
		button_report = bytearray([ 0xf4, g_btn_state >> 8, g_btn_state & 0xff, btn_mask >> 8, btn_mask & 0xff ])
		mch22.fpga_send(bytes(button_report))

def on_action_btn_a(pressed):
	button_report(1 << 9, pressed)

def on_action_btn_b(pressed):
	button_report(1 << 10, pressed)

def on_action_btn_home(pressed):
	button_report(1 << 5, pressed)

def on_action_btn_menu(pressed):
	global g_level
	global g_playing

	button_report(1 << 6, pressed)
	if pressed:
		if g_playing:
			mch22.fpga_disable()
			mch22.lcd_mode(0)
			level_buttons()
			g_playing = False
		# switching back to AW not easy to implement
		#else:
		#	mch22.lcd_mode(1)
		#	g_playing = True
		
def on_action_btn_select(pressed):
	button_report(1 << 7, pressed)

def on_action_btn_start(pressed):
	button_report(1 << 8, pressed)

def on_action_btn_left(pressed):
	button_report(1 << 2, pressed)

def on_action_btn_right(pressed):
	button_report(1 << 3, pressed)

def on_action_btn_up(pressed):
	global g_level
	global g_playing

	button_report(1 << 1, pressed)
	if not g_playing and g_level > 1 and pressed:
		level_button(g_level, False)
		g_level -= 1
		level_button(g_level, True)
		display.flush()


def on_action_btn_down(pressed):
	global g_level
	global g_playing

	button_report(1 << 0, pressed)
	if not g_playing and g_level < 8 and pressed:
		level_button(g_level, False)
		g_level += 1
		level_button(g_level, True)
		display.flush()

def on_action_btn_press(pressed):
	global g_level
	global g_playing

	button_report(1 << 4, pressed)
	if not g_playing:
		if g_level == 8:
			mch22.fpga_disable()
			mch22.lcd_mode(0)
			mch22.exit_python()
		else:
			str_level = str(g_level)
			display.drawFill(0x000000)
			display.drawText(10, 10, "Loading", 0xFFFFFF, "dejavusans20")
			display.drawText(10, 30, "Another world level " + str_level, 0xFFFFFF, "dejavusans20")
			display.flush()
			with open(getcwd() + "/write_spi.bin", "rb") as f:
				mch22.fpga_load(f.read())
			load(str_level)
			start(str_level)
			g_playing = True

def setup():
	buttons.attach(buttons.BTN_A, on_action_btn_a)
	buttons.attach(buttons.BTN_B, on_action_btn_b)
	buttons.attach(buttons.BTN_HOME, on_action_btn_home)
	buttons.attach(buttons.BTN_MENU, on_action_btn_menu)
	buttons.attach(buttons.BTN_SELECT, on_action_btn_select)
	buttons.attach(buttons.BTN_START, on_action_btn_start)
	buttons.attach(buttons.BTN_LEFT, on_action_btn_left)
	buttons.attach(buttons.BTN_RIGHT, on_action_btn_right)
	buttons.attach(buttons.BTN_UP, on_action_btn_up)
	buttons.attach(buttons.BTN_DOWN, on_action_btn_down)
	buttons.attach(buttons.BTN_PRESS, on_action_btn_press)
	level_buttons()

def load(level):
	spi_cmd_nop2 = bytearray(2)
	spi_cmd_nop2[0] = 0xff
	spi_cmd_fread_get = bytearray(1)
	spi_cmd_fread_get[0] = 0xf8
	spi_cmd_resp_ack = bytearray(12)
	spi_cmd_resp_ack[0] = 0xfe
	spi_cmd_fread_put = bytearray(0x401)
	spi_cmd_fread_put[0] = 0xf9
	with open(getcwd() + "/" + level + ".raw", "rb") as f:
		for k in range(0, 1643):
			# wait for IRQ
			while mch22.fpga_transaction(bytes(spi_cmd_nop2))[1] == 0:
				pass
			mch22.fpga_send(bytes(spi_cmd_fread_get))
			mch22.fpga_transaction(bytes(spi_cmd_resp_ack))
			#print(".", end="")
			spi_cmd_fread_put = bytearray(0x401)
			spi_cmd_fread_put[0] = 0xf9
			data = f.read(1024)
			data_len = len(data)
			if data_len < 1024:
				spi_cmd_fread_put = bytearray(0x401)
				spi_cmd_fread_put[0] = 0xf9
			spi_cmd_fread_put[1:data_len] = data
			mch22.fpga_send(bytes(spi_cmd_fread_put))

def start(level):
	with open(getcwd() + "/" + level + ".bit", "rb") as f:
		mch22.lcd_mode(1)
		mch22.fpga_load(f.read())

setup()
