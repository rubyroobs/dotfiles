return {
  rosewater = 0xFFF2D5CF,
	flamingo = 0xFFEEBEBE,
	pink = 0xFFF4B8E4,
	mauve = 0xFFCA9EE6,
	red = 0xFFE78284,
	maroon = 0xFFEA999C,
	peach = 0xFFEF9F76,
	yellow = 0xFFE5C890,
	green = 0xFFA6D189,
	teal = 0xFF81C8BE,
	sky = 0xFF99D1DB,
	sapphire = 0xFF85C1DC,
	blue = 0xFF8CAAEE,
	lavender = 0xFFBABBF1,

	text = 0xFFc6d0f5,
	subtext1 = 0xFFb5bfe2,
	subtext0 = 0xFFa5adce,
	overlay2 = 0xFF949cbb,
	overlay1 = 0xFF838ba7,
	overlay0 = 0xFF737994,
	surface2 = 0xFF626880,
	surface1 = 0xFF51576d,
	surface0 = 0xFF414559,

	base = 0xFF303446,
	mantle = 0xFF292C3C,
	crust = 0xFF232634,

  transparent = 0x00000000,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
