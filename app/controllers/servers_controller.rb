# Copyright (c) 2016 Nathan Baum

Thread.abort_on_exception = true

class ServersController < ApplicationController

  include Tubesock::Hijack

  before_action :set_servers
  before_action :set_server, except: [:new]

  def index
    @servers = @servers.includes(:appliance, :bundle, :zone).order(:id)
    @servers = @servers.where("bundle_id = 0 OR bundle_id IS NULL") unless params[:all]
    @servers = @servers.where("is_template = FALSE") unless params[:templates]
    @servers = @servers.where("is_template = TRUE") if params[:templates]
    @servers = @servers.where("tags @> ARRAY[?]::VARCHAR[]", params[:tags].split(",")) if params[:tags]
    @servers = @servers.page(params[:page]).decorate
  end

  def new
    @server = @servers.new
  end

  def create
    @server = @servers.new(server_params)
    if @server.save
      redirect_to @server, notice: "Server was successfully created."
    else
      render :new
    end
  end

  def update
    if @server.update(server_params)
      redirect_to :back, notice: "Server was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @server.destroy
    redirect_to :servers, notice: "Server destroyed."
  end

  def start
    @server.start
    redirect_to :back, notice: "Server started."
  end

  def pause
    @server.pause
    redirect_to :back, notice: "Server paused."
  end

  def unpause
    @server.unpause
    redirect_to :back, notice: "Server unpaused."
  end

  def reset
    @server.reset
    redirect_to :back, notice: "Server reset."
  end

  def stop
    @server.stop
    redirect_to :back, notice: "Server stopped."
  end

  def suspend
    @server.suspend
    redirect_to :back, notice: "Server suspended."
  end

  def resume
    @server.resume
    redirect_to :back, notice: "Server resumed."
  end

  def clone
    redirect_to @server.clone, notice: "Server cloned."
  end

  def migrate
    current_user.job(:migrate_server, server: @server, host_id: params[:server][:host_id])
    redirect_to :back
  end

  def evict
    current_user.job(:migrate_server, server: @server)
    redirect_to :back
  end

  def push
    @server.push
    redirect_to :back
  end

  def unaddress
    @server.addresses.update_all server_id: nil
    redirect_to :back
  end

  # TODO: Figure out what to do about errors.
  def socket
    hijack do |ws|
      sock = TCPSocket.new(*@server.vnc_address)
      Thread.new do
        loop do
          IO.select([sock], [], [sock])
          begin
            data = sock.recv(8192)
            raise "EOF" if data.length == 0
            ws.send_data Base64.strict_encode64(data)
          rescue => e
            ws.close
            break
          end
        end
      end
      ws.onmessage do |data|
        begin
          sock << Base64.decode64(data)
        rescue
          sock.close
          ws.close
        end
      end
    end
  end

  def guest_password
    p = params.require(:password).permit(:username, :password)
    @server.guest_password! p[:username], p[:password]
    redirect_to :back
  end

  def guest_execute
    job = current_user.job(:guest_execute, server: @server, command: params.require(:execute).permit(:command)[:command])
    sleep 0.5
    redirect_to job_url(job)
  end

  def script
    if params[:script]
      job = current_user.job(:execute_script, server: @server, script: params.require(:script).permit(:id)[:id])
      sleep 0.5
      redirect_to job_url(job)
    else
      job = current_user.job(:execute_script, server: @server)
      sleep 0.5
      redirect_to job_url(job)
    end
  end

  private

  def set_servers
    @servers = current_account.servers
  end

  def set_server
    return if params[:id].nil?
    @server = if current_user.administrator?
                Server.find(params[:id])
              else
                @servers.find(params[:id])
              end
    @server = @server.decorate unless request.method == "POST"
  end

  def server_params
    p = params.require(:server).permit(:name, :cores, :memory, :storage,
                                   :password, :state, :affinity_group,
                                   :appliance_data, :template_id,
                                   :host_id, :account_id, :zone_id,
                                   :appliance_id, :bundle_id,
                                   :published_at, :base_id, :current_id,
                                   :iso_id, :machine_type, :boot_order,
                                   :pinned, :new_host, :notes, :is_template, :tags,
                                   :hda_id, :hdb_id, :hdc_id, :hdd_id,
                                   :custom_guest_data, :mhz,
                                   :root_id, :script, :networks => [:assign])
    p[:networks] = p[:networks].select{|id,a| a["assign"] == "1"}.keys if p[:networks]
    p[:tags] = p[:tags].split(",") if p[:tags]
    p
  end

end
