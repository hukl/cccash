module MockCashbox
  def cashbox_response_for( url, timeout=5)
    case url
    when "/open"
      "open"
    end
  end
end