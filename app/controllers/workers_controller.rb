class WorkersController < ApplicationController
  def status
    worker_id = params[:id]
    container = SidekiqStatus::Container.load(worker_id)

    puts '------------------------------------------------------------------'
    puts "container.pct_complete has the value: #{container.pct_complete}"
    puts '------------------------------------------------------------------'
    respond_to do |format|
      format.json do
        render(json: {
          percentage_done: container.pct_complete
        }
              )
      end
    end
  end
end
