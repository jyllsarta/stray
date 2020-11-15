class ProfileBuilder
  def initialize(user)
    @user = user
  end

  def extract
    {
      parameters: {
        spica: @user.characters.spica.first.parameters,
        tirol: @user.characters.tirol.first.parameters,
      },
      equips: {
      },
      achievements: {
      },
    }
  end
end
