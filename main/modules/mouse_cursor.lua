mouse_hovering_id = nil
function calculate_cursor()
	defos.set_cursor(mouse_hovering_id and defos.CURSOR_HAND)
end