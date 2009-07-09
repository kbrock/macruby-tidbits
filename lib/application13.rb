require 'hotcocoa'
class Application
  include HotCocoa
  FULL={:expand => [:width,:height]}
  SHOW=[0,0,0,100]
  def start
    application :name => "MyTableView" do |app|
      app.delegate = self
      window(:title => "MyTableView",
        :frame => [10, 620, 330, 230]) do |win|
        win << split_view(:horizontal => true,
          :layout => FULL,:frame=>SHOW) do |sp|
          sp << sc=scroll_view(:frame => SHOW)
          sc << @tv=table_view(:data=>[],:columns=>[])
          sp << @pr=text_field(:text => 'type here',
            :font => font(:name=>'Monaco', :size => 16),
            :on_action => Proc.new {|t| type(t.to_s)})
        end #sp
        win.contentView.margin = 5
        win.makeFirstResponder @pr
        win.will_close { exit }
      end #window (win)
    end #application
  end
  def type(t)
    values={}
    t.split.each_with_index do |v,i|
      values["c#{i}"]=v
      if i >= @tv.tableColumns.size
        @tv.tableColumns << column(:id=>"c#{i}",
          :title=>"Word #{i+1}")
      end
    end
    @tv.dataSource.data << values
    @tv.reloadData
  end
end
Application.new.start
#thanks http://everburning.com/news/heating-up-with-hotcocoa-part-ii/
