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
          :layout => FULL) do |sv|
          sv << scroll_view(:frame => SHOW) do |sc|
            sc << @table=table_view(
              :data => [], :columns => [
                column(:id => :c1, :title => "Word 1"),
                column(:id => :c2, :title => "Word 2"),
                column(:id => :c3, :title => "...")])
          end #sc
          sv << @prompt = text_field(:text => 'type here',
            :font => font(:name=>'Monaco', :size => 16),
            :on_action => Proc.new {|t| type(t)})
        end #sv
        win.contentView.margin = 5
        win.makeFirstResponder @prompt
        win.will_close { exit }
      end #window (win)
    end #application
  end
  def type(t)
    c1,c2,*c3=t.to_s.split ; c3=c3.join ' '
    @table.dataSource.data << {:c1=>c1,:c2=>c2,:c3=>c3}
    @table.reloadData
  end
end
a=Application.new.start
#thanks http://everburning.com/news/heating-up-with-hotcocoa-part-ii/
