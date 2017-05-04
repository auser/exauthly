defmodule Newline.Schema.Types.Auth do
  use Absinthe.Schema.Notation

  object :session do
    field :token, :string
  end
  
  object :auth_mutations do
    
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      
      resolve &Newline.UserResolver.login/2
    end

  end
end
