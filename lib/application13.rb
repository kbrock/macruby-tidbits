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
            @num_cols=1
            sc << @table=table_view(
              :data => [], :columns => [
                column(:id => :c1, :title => "Word 1")])
          end #sc
          sv << @prompt = text_field(:text => 'type here',
            :font => font(:name=>'Monaco', :size => 16),
            :on_action => Proc.new {|t| type(t.to_s)})
        end #sv
        win.contentView.margin = 5
        win.makeFirstResponder @prompt
        win.will_close { exit }
      end #window (win)
    end #application
  end
  def type(t)
    c=t.split
    #add extra columns
    ((@num_cols+1)..c.size)).each do |i|
      @table.dataSource.columns <<
        column(:id => "c#{i}", :title => "Word #{i}")
    end
    values={}
    c.each_with_index do |v,i| values["c#{i}".to_sym]=v end
    @table.dataSource.data << values
    @table.reloadData
  end
end
a=Application.new.start
#thanks http://everburning.com/news/heating-up-with-hotcocoa-part-ii/
