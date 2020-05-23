#=========================================================================
# ● ◦ [VX] Animation Bug Fixed ◦ □ by Woratana (21/05/2008)
# * Fixed bug that animation will follow screen, not stay on character~ *
# * You can place this script in any slot below the slot 'Sprite_Base'
#-------------------------------------------------------------------------
class Sprite_Base < Sprite
  alias wora_bugfix_sprbas_upd update
  def update
    if !@animation.nil?
      if @animation.position == 3
        if viewport == nil
          @animation_ox = Graphics.width / 2
          @animation_oy = Graphics.height / 2
        else
          @animation_ox = viewport.rect.width / 2
          @animation_oy = viewport.rect.height / 2
        end
      else
        @animation_ox = x - ox + width / 2
        @animation_oy = y - oy + height / 2
        if @animation.position == 0
          @animation_oy -= height / 2
        elsif @animation.position == 2
          @animation_oy += height / 2
        end
      end
    end
    wora_bugfix_sprbas_upd
  end
end