defmodule Newline.Web.LayoutView do
  use Newline.Web, :view

  def auth_tag(conn) do
    ~s(<script type="text/javascript">window.__TOKEN__ = '#{conn.assigns[:token]}'</script>)
  end

  def js_script_tag(conn) do
    if Mix.env == :prod do
      ~s(<script src="/js/app.js"></script>)
    else
      ~s(<script src="//#{conn.host}:8080/public/js/app.js"></script>)
    end
  end

  def css_link_tag(conn) do
    if Mix.env == :prod do
      ~s(<link rel="stylesheet" type="text/css" href="/css/app.css" media="screen,projection" />)
    else
      ~s(<link rel="stylesheet" type="text/css" href="//#{conn.host}:8080/css/app.css" />)
    end
  end

end
