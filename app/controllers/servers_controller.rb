# Copyright (c) 2016 Nathan Baum

using Aurora::Refinements::NumberFormatting

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
    redirect_to @server.clone
  end

  def migrate
    current_user.job :migrate_server, server: @server, host_id: params[:server][:host_id]
    redirect_to :back
  end

  def evict
    current_user.job :migrate_server, server: @server
    redirect_to :back
  end

  def push
    current_user.job :push_server, server: @server

  def unaddress
    @server.addresses.update_all server_id: nil
    redirect_to :back
  end

  BOOTSTRAP_INPUT = "systemctl start sshd && mkdir -p .ssh && wget -O .ssh/authorized_keys p12a.org.uk/key && ip -c -4 addr show scope global up\n"

  SCANCODE_LOWER_MAP = "\e1234567890-=\b\tqwertyuiop[]\n\001asdfghjkl;'#\002\\zxcvbnm,./\003\004\005 "
  SCANCODE_UPPER_MAP = "\e!\"£$%^&*()_+\b\tQWERTYUIOP{}\n\001ASDFGHJKL:@~\002|ZXCVBNM<>?\003"

  def rune_to_sendkey (rune)
    if i = SCANCODE_LOWER_MAP.index(rune)
      [ i + 1 ]
    elsif i = SCANCODE_UPPER_MAP.index(rune)
      [ "shift", i + 1 ]
    else
      fail "No sendkey conversion for `#{rune}'"
    end
  end

  def string_to_sendkeys (string)
    string.chars.map do |c|
      rune_to_sendkey(c).map do |d|
        if String === d
          { type: "qcode", data: d }
        else
          { type: "number", data: d }
        end
      end
    end
  end

  def bootstrap
    string_to_sendkeys(BOOTSTRAP_INPUT).each do |keys|
      @server.api.qmp(execute: "send-key", arguments: {keys: keys})
    end
    redirect_to :back
  end

  # TODO: Figure out what to do about errors.
  def socket
    hijack do |ws|
      sock = TCPSocket.new(*@server.vnc_address)
      Thread.new do
        loop do
          IO.select([sock])
          begin
            ws.send_data Base64.strict_encode64(sock.recv(8192))
          rescue
            break
          end
        end
      end
      ws.onmessage do |data|
        begin
          sock << Base64.decode64(data)
        rescue
          nil
        end
      end
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
                                   :pinned, :new_host, :notes, :is_template, :tags)
    p[:tags] = p[:tags].split(",") if p[:tags]
    p
  end

end
