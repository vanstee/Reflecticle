framework 'Cocoa'

main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
    require path if path != main
    require 'net/http'
    require 'uri'
    require 'json'
end

NSApplicationMain(0, nil)
