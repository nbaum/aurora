# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

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
    current_user.job :destroy_server, server: @server
    redirect_to :servers
  end

  def start
    current_user.job :start_server, server: @server
    redirect_to :back
  end

  def pause
    current_user.job :pause_server, server: @server
    redirect_to :back
  end

  def unpause
    current_user.job :unpause_server, server: @server
    redirect_to :back
  end

  def reset
    current_user.job :reset_server, server: @server
    redirect_to :back
  end

  def stop
    current_user.job :stop_server, server: @server
    redirect_to :back
  end

  def suspend
    current_user.job :suspend_server, server: @server
    redirect_to :back
  end

  def resume
    current_user.job :resume_server, server: @server
    redirect_to :back
  end

  def clone
    j = current_user.job :clone_server, server: @server
    if sid = j.state["new_server_id"]
      redirect_to server_path(sid)
    else
      redirect_to :back
    end
  end

  def migrate
    current_user.job :migrate_server, server: @server, host_id: params[:server][:host_id]
    redirect_to :back
  end

  def evict
    current_user.job :migrate_server, server: @server
    redirect_to :back
  end

  # TODO: Figure out what to do about errors.
  def socket
    hijack do |ws|
      sock = TCPSocket.new(*@server.vnc_address)
      Thread.new do
        loop do
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
    if current_user.administrator?
      @server = Server.find(params[:id])
    else
      @server = @servers.find(params[:id])
    end
    @server = @server.decorate unless request.method == "POST"
  end

  def server_params
    params.require(:server).permit(:name, :cores, :memory, :storage,
                                   :password, :state, :affinity_group,
                                   :appliance_data, :template_id,
                                   :host_id, :account_id, :zone_id,
                                   :appliance_id, :bundle_id,
                                   :published_at, :base_id, :current_id,
                                   :iso_id, :machine_type, :boot_order,
                                   :pinned, :new_host)
  end

end
