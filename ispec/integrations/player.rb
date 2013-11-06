class ChineseIntegration::Player

  def initialize
    @state = State.new
  end

  def visits(somewhere)
    ChineseIntegration::Actions::Visits.new(_state).call somewhere
  end

  def clicks(something)
    ChineseIntegration::Actions::Clicks.new(_state).call something
  end

  def selects(something)
    ChineseIntegration::Actions::Selects.new(_state).call something
  end

  def picks(sometime)
    ChineseIntegration::Actions::Picks.new(_state).call sometime
  end

  private

  def _state
    @state
  end

end