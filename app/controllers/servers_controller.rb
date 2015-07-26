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
    current_user.job "Destroy server", @server do |_, server|
      server.lock
      server.destroy
    end.wait
    redirect_to :servers
  end

  def start
    current_user.job "Start server", @server do |_, server|
      server.lock
      server.start
    end.wait
    redirect_to :back
  end

  def pause
    current_user.job "Pause server", @server do |_, server|
      server.lock
      server.pause
    end.wait
    redirect_to :back
  end

  def unpause
    current_user.job "Unpause server", @server do |_, server|
      server.lock
      server.unpause
    end.wait
    redirect_to :back
  end

  def reset
    current_user.job "Reset server", @server do |_, server|
      server.lock
      server.reset
    end.wait
    redirect_to :back
  end

  def stop
    current_user.job "Stop server", @server do |_, server|
      server.lock
      server.stop
    end.wait
    redirect_to :back
  end

  def suspend
    current_user.job "Suspend server", @server do |_, server|
      server.lock
      server.suspend
    end.wait
    redirect_to :back
  end

  def resume
    current_user.job "Resume server", @server do |_, server|
      server.lock
      server.resume
    end.wait
    redirect_to :back
  end

  def clone
    j = current_user.job "Clone server", @server do |j, server|
      server.lock
      new_server = @server.clone
      new_server.save!
      j[:new_server] = new_server
    end.wait
    if j && j[:new_server]
      redirect_to j[:new_server]
    else
      redirect_to :back
    end
  end

  def migrate
    current_user.job("Migrate server", @server, Host.find(params[:server][:host_id])) do |_, server, host|
      server.lock
      server.migrate(host)
    end.wait
    redirect_to :back
  end

  def evict
    current_user.job("Evict server #{@server.name}", @server) do |j, server|
      server.evict
      j.finish "Server moved to #{server.host.name}"
    end.wait
    redirect_to :back
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
