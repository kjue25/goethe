class PagesController < ApplicationController

  def index
    if session[:user_id]
      session_user = User.find(session[:user_id])
      @page = session_user.page
    end
  end

  def new
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?)
      @page = Page.new
    else
      @page = @session_user.page
    end
    #panel = @page.panels.build
    #panel.save #this is necessary for panel to save
  end

  def create
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?)
      @page = Page.new(page_params)
    else
      @page = @session_user.page
    end
    @page.user_id = @session_user.id
    @page.site_name = params[:page][:site_name]
    @page.description = params[:page][:description]

    create_panel(params[:page][:panels_attributes], @page)

    if @page.save
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @page.user_id = @session_user.id
    @page.site_name = params[:page][:site_name]
    @page.description = params[:page][:description]

=begin
    for panel in params[:page][:panels_attributes]
      new_panel = @page.panels.build
      #new_panel = Panel.new(panel[1])
      new_panel.page_id = @page.id
      new_panel.panel_name = panel[1][:panel_name]
      new_panel.display = panel[1][:display]
      new_panel.panel_type = panel[1][:panel_type]

      uploaded = params

      new_panel.save
    end
=end
    create_panel(params[:page][:panels_attributes], @page)

    if @page.save  
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Could not update. Please try again."
    end
  end

  private

  def page_params
    params.require(:page).permit(:site_name, :description, panels_attributes: [:panel_name, :display, :panel_type, :background_file, :_destroy])
  end

  def create_panel(attributes, cur_page)
    if !(attributes.nil?)
      for panel in attributes
        #new_panel = Panel.new(panel[1])
        new_panel = cur_page.panels.build
        new_panel.page_id = cur_page.id
        new_panel.panel_name = panel[1][:panel_name]
        new_panel.display = panel[1][:display]
        new_panel.panel_type = panel[1][:panel_type]

        uploaded = panel[1][:background]
        if !(uploaded.nil?)
          File.open(Rails.root.join('app','assets','images', uploaded.original_filename), 'wb') do |file|
            file.write(uploaded.read)
          end
          new_panel.background_file = panel[1][:background].original_filename
        end
        new_panel.save #add validation here
      end
    end
  end

end
