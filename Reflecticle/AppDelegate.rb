class AppDelegate
    attr_accessor :window, :menu, :api_key, :projects, :project, :post, :menu_item_view

    def awakeFromNib
        @api_key.stringValue = NSUserDefaults.standardUserDefaults["api_key"]

        @status_bar = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
        @status_bar.setMenu(@menu)
        @status_bar.setTitle("Reflecticle")
        @status_bar.setHighlightMode(true)

        @menu_item = NSMenuItem.new
        @menu_item.setView(@menu_item_view)
        @menu.insertItem(@menu_item, atIndex: 0)

        api_key = NSUserDefaults.standardUserDefaults["api_key"]
        unless api_key.empty?
            uri = URI.parse("http://www.reflecticle.com/api/projects.json?api_key=#{api_key}")
            @projects ||= Hash[JSON.parse(Net::HTTP.get_response(uri).body).map { |p| [p["id"], p["name"]] }]
            @project.removeAllItems
            @project.addItemsWithTitles(@projects.values)
        end
    end

    def populate(sender)
        p @project.itemArray
    end

    def post(sender)
        api_key = NSUserDefaults.standardUserDefaults["api_key"]
        if !api_key.empty? && !@post.stringValue.empty?
            uri = URI.parse("http://www.reflecticle.com/api/activities/create.json?api_key=#{api_key}&project_id=1&description=#{@post.stringValue}")
            p Net::HTTP.get_response(uri)
            @post.stringValue = ""
        end
    end

    def save(sender)
        NSUserDefaults.standardUserDefaults["api_key"] = @api_key.stringValue
        NSUserDefaults.standardUserDefaults.synchronize
        @window.performClose(true)
    end
end
