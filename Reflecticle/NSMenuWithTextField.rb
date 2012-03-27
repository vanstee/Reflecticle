class NSMenuItemWithTextField < NSMenuItem
    def setView(view)
        text_field = NSTextField.alloc.init
        view.addSubview(text_field)
    end
end
