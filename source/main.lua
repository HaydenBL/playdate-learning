
-- uncomment one
-- import 'capybara-game'
import 'text-wheel'

if playdate.update == nil then
	playdate.update = function() end
	playdate.graphics.drawText("Uncomment one of the import statements.", 15, 100)
end
