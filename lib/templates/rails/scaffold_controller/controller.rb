<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  before_action :set_<%= plural_table_name %>
  before_action :set_<%= singular_table_name %>, except: [:new]

  def index
    @<%= plural_table_name %> = @<%= plural_table_name %>.order(:id).page(params[:page]).decorate
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build("@#{plural_table_name}") %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build("@#{plural_table_name}", "#{singular_table_name}_params") %>
    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %>
    else
      render :new
    end
  end

  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %>
    else
      render :edit
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end

  private

  def set_<%= plural_table_name %>
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
  end

  def set_<%= singular_table_name %>
    return if params[:id].nil?
    @<%= singular_table_name %> = <%= orm_class.find("@#{plural_table_name}", "params[:id]") %>.decorate
  end

  def <%= singular_table_name%>_params
    <%- if attributes_names.empty? -%>
    params[:<%= singular_table_name %>]
    <%- else -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
  end

end
<% end -%>
