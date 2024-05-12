return {
    black = 0xFF51576D,
    white = 0xFFB5BFE2,
    red = 0xFFE78284,
    green = 0xFFA6D189,
    yellow = 0xFFE5C890,
    orange = 0xFFEF9F76,
    blue = 0xFF8CAAEE,
    magenta = 0xFFF4B8E4,
    grey = 0xff545454,
    transparent = 0x00000000,
    comment = 0xFFC6D0F5,
    background = 0xFF303446,

    -- TODO: find better values for these/more consistent?
    border = 0xffe0e1e1,
    border2 = 0x3De0e1e1,
    fontColor = 0xff212121,
    hiLight = 0xff212121,
    inactive = 0xfff9f9f9,
    inactive2 = 0x66f9f9f9,
    active = 0xff919fa3,
    hover = 0xff292f31,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then
            return color
        end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end
}
