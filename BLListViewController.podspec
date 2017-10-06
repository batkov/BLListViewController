#
# Be sure to run `pod lib lint BLListViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BLListViewController"
  s.version          = "0.9.11"
  s.summary          = "BLListViewController is used to display information got from BLListDataSource."

  s.description      = <<-DESC
  BLListViewController is used to display information got from BLListDataSource. Example is written with usage of BLParseFetch to demontrate abilities of each of lib.
                       DESC

  s.homepage         = "https://github.com/batkov/BLListViewController"
  s.license          = 'MIT'
  s.author           = { "Hariton Batkov" => "batkov@i.ua" }
  s.source           = { :git => "https://github.com/batkov/BLListViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'BLListDataSource'
  s.dependency 'MJRefresh'
  s.dependency 'DateTools'
end
