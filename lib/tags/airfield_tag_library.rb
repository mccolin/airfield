# AIRFIELD
# AirfieldTagLibrary -- Radius tag library for template rendering

# Create a testable tag library:
class AirfieldTagLibrary < AxTags::TagLibrary
  tag "anchor" do |t|
    %{<a class="awesome_anchor" href="http://awesometown.com/">I am Awesome!</a>}
  end
end
