
Pod::Spec.new do |s|

  s.name         = "RingLibrary"
  s.version      = "1.0.0"
  s.summary      = "A Progress Ring with a Button inside."


  s.description  = "a stylish simple way to combine progress and button. 3 different color shemes available plus gradient option"

  s.homepage     = "https://mouroumm.wixsite.com/marvinmouroum"

  s.license      = "MIT"


  s.author             = { "Marvin Martin Etoga Mouroum" => "mouroum.m@gmail.com" }

   s.platform     = :ios, "11.0"


  s.source       = { :git => "https://github.com/marvinmouroum/ProgressRing.git", :tag => "1.0.1" }
   #s.source       = { :path => '.' }

  s.source_files  = "ProgressRing", "RingLibrary/*.{m,h,swift}"

   s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
