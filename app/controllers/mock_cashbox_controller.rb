class MockCashboxController < ApplicationController
  def open
    log_debug('öffnet sich')
    kasching = File.expand_path(File.dirname(__FILE__) + "/../../public/cashbox_open.wav")
    system "mplayer '#{kasching}'"
    render :text => 'open'
  end
  def status
    if rand < 0.1
      log_debug "immernoch offen"
      render :text => 'open'
    else
      log_debug "endlich geschlossen"
      render :text => 'closed'
    end
  end
  def wait_for_close
    how_long = 7
    log_debug("warte #{how_long} Sekunden, dann ist Schublade wieder geschlossen")
    sleep how_long
    render :text => 'closed'
  end
  def reinit
    log_debug('wird neu initialisiert.')
    status
    return
  end
  def print
    logger.info(params.inspect.to_s)
    render :text => 'printed'
  end

  private
  def log_debug(message)
    logger.debug "=== Schublade: " + message
  end
end
