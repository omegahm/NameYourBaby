SPIN_SPEED = 30
SPINNER = %w[ ⠋ ⠙ ⠚ ⠞ ⠖ ⠦ ⠴ ⠲ ⠳ ⠓ ]
$spin_place = 0

def spin(current = nil, size = nil, speed: SPIN_SPEED)
  spinner = SPINNER.map { (it * speed).chars }.flatten
  print "\r#{spinner[$spin_place]}"
  print " (#{current}/#{size})" if current && size
  $spin_place = ($spin_place + 1) % SPINNER.length
end
