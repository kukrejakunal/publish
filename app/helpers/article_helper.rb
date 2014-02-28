module ArticleHelper

  def status_label(status)
    if status == Article::STATE[:draft]
      "warning"
    elsif status == Article::STATE[:complete]
       "info"
    elsif status == Article::STATE[:publish]
       "success"
    else
      "default"
    end

  end
end