# Fix the gradient_fill_rect method bug # by Woratana
class Bitmap
  alias wora_bug_bmp_gfr gradient_fill_rect unless method_defined?('wora_bug_bmp_gfr')
  def gradient_fill_rect(*args)
    args.pop if args.size == 7 and !args.last
    wora_bug_bmp_gfr(*args)
  end
end