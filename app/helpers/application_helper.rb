module ApplicationHelper
  def full_title(page_title = '')  # full_titleメソッドを定義
    base_title = 'タスクシェア'
    if page_title.blank?
      base_title  # トップページはタイトル
    else
      "#{page_title} - #{base_title}" # トップ以外のページはタイトル「〇〇 - タスクシェア」
    end
  end
end
