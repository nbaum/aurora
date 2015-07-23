using Aurora::Refinements::NumberFormatting

Thread.abort_on_exception = true

class ServersController < ApplicationController
  include Tubesock::Hijack

  before_action :set_servers
  before_action :set_server, except: [:new]

  def index
    @servers = @servers.includes(:appliance, :bundle, :zone).order(:id).page(params[:page]).decorate
  end

  def new
    @server = @servers.new
  end

  def create
    @server = @servers.new(server_params)
    if @server.save
      redirect_to @server, notice: 'Server was successfully created.'
    else
      render :new
    end
  end

  def update
    if @server.update(server_params)
      redirect_to :back, notice: 'Server was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @server.destroy
    redirect_to servers_url, notice: 'Server was successfully destroyed.'
  end

  def start
    @server.start
    redirect_to :back, notice: 'Server started'
  end

  def pause
    @server.pause
    redirect_to :back, notice: 'Server paused'
  end

  def unpause
    @server.unpause
    redirect_to :back, notice: 'Server resumed'
  end

  def reset
    @server.reset
    redirect_to :back, notice: 'Server reset'
  end

  def stop
    @server.stop
    redirect_to :back, notice: 'Server stopped'
  end

  def suspend
    @server.suspend
    redirect_to :back, notice: 'Server suspended'
  end

  def resume
    @server.resume
    redirect_to :back, notice: 'Server resumed'
  end

  def clone
    new_server = @server.clone
    redirect_to new_server, notice: 'Server copied' if new_server.save
  end

  def migrate
    @server.migrate(Host.find(params[:server][:host_id]))
    redirect_to :back, notice: 'Server migrated'
  end

  # TODO: Figure out what to do about errors.
  def socket
    hijack do |ws|
      sock = TCPSocket.new(*@server.vnc_address)
      Thread.new do
        while true
          IO.select([sock])
          ws.send_data Base64.strict_encode64(sock.recv(8192)) rescue break
        end
      end
      ws.onmessage do |data|
        sock << Base64.decode64(data) rescue nil
      end
    end
  end

  private

  def set_servers
    @servers = current_account.servers
  end

  def set_server
    return if params[:id].nil?
    @server = @servers.find(params[:id])
    @server = @server.decorate unless request.method == 'POST'
  end

  def server_params
    params.require(:server).permit(:name, :cores, :memory, :storage,
                                   :password, :state, :affinity_group,
                                   :appliance_data, :template_id,
                                   :host_id, :account_id, :zone_id,
                                   :appliance_id, :bundle_id,
                                   :published_at, :base_id, :current_id,
                                   :iso_id, :machine_type, :boot_order)
  end

end
