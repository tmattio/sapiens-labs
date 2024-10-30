(* For simplicity, this module simply logs messages to the terminal.

   You should replace it by a proper e-mail or notification tool. *)

module type S = sig
  val deliver_confirmation_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t

  val deliver_reset_password_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t

  val deliver_update_email_instructions
    :  url:string
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t

  val deliver_deleted_account_email
    :  Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t
end

module Console : S = struct
  let log_src =
    Logs.Src.create
      ~doc:"User notifier to that logs messages to the terminal"
      "sapiens.account.user_notifier"

  module Log = (val Logs_lwt.src_log log_src : Logs_lwt.LOG)

  let deliver email body =
    let open Lwt_result.Syntax in
    let+ () = Log.info (fun m -> m "%s" body) |> Lwt_result.ok in
    email, body

  let deliver_confirmation_instructions ~url user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|

    ==============================

    Hi %s,

    You can confirm your account by visiting the url below:

    %s

    If you didn't create an account with us, please ignore this.

    ==============================
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_reset_password_instructions ~url user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|

    ==============================

    Hi %s,

    You can reset your password by visiting the url below:

    %s

    If you didn't create an account with us, please ignore this.
        
    Thanks,
    The Sapiens Team

    ==============================
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_update_email_instructions ~url user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|
      
    ==============================

    Hi %s,

    You can change your e-mail by visiting the url below:

    %s

    If you didn't create an account with us, please ignore this.
        
    Thanks,
    The Sapiens Team

    ==============================
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_deleted_account_email user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|
            
          ==============================
      
          Hi %s,
      
          This email is to confirm that your account and all your datasets have been deleted from Sapiens_backend.

          We're sorry to see you go. You can reach out to us at support@sapiens.com if you have any questions or would like to share feedback.
        
          Thanks,
          The Sapiens Team
      
          ==============================
      |}
         (Account_user.Username.to_string user.username))
end

module Email = struct
  let gen_boundary length =
    let gen () =
      match Random.int (26 + 26 + 10) with
      | n when n < 26 ->
        int_of_char 'a' + n
      | n when n < 26 + 26 ->
        int_of_char 'A' + n - 26
      | n ->
        int_of_char '0' + n - 26 - 26
    in
    let gen _ = String.make 1 (char_of_int (gen ())) in
    String.concat "" (Array.to_list (Array.init length gen))

  let mailgun_send params =
    let domain = "sandbox12a89fcae8124073bbeb847534530d72.mailgun.org" in
    let api_key = Config.mailgun_api_key in
    let authorization = "Basic " ^ Base64.encode_exn ("api:" ^ api_key) in
    let _boundary = gen_boundary 24 in
    let header_boundary = "------------------------" ^ _boundary in
    let boundary = "--------------------------" ^ _boundary in
    let content_type = "multipart/form-data; boundary=" ^ header_boundary in
    let form_value =
      List.fold_left
        (fun run (key, value) ->
          run
          ^ Printf.sprintf
              "%s\r\nContent-Disposition: form-data; name=\"%s\"\r\n\r\n%s\r\n"
              boundary
              key
              value)
        ""
        params
    in
    let headers =
      Cohttp.Header.of_list
        [ "Content-Type", content_type; "Authorization", authorization ]
    in
    let uri = Printf.sprintf "https://api.mailgun.net/v3/%s/messages" domain in
    let body =
      Cohttp_lwt.Body.of_string
        (Printf.sprintf "%s\r\n%s--" form_value boundary)
    in
    Cohttp_lwt_unix.Client.post ~headers ~body (Uri.of_string uri)

  let deliver ~(email : Account_user.Email.t) ~subject content =
    let open Lwt.Syntax in
    let* resp, resp_body =
      mailgun_send
        [ ( "from"
          , "Sapiens \
             <postmaster@sandbox12a89fcae8124073bbeb847534530d72.mailgun.org>" )
        ; "to", Account_user.Email.to_string email
        ; "subject", subject
        ; "text", content
        ]
    in
    let status = Cohttp.Response.status resp |> Cohttp.Code.code_of_status in
    match status with
    | 200 | 202 ->
      Logs.debug (fun m -> m "EMAIL: Successfully sent email using mailgun");
      Lwt.return @@ Ok (email, content)
    | _ ->
      let* body = Cohttp_lwt.Body.to_string resp_body in
      Logs.debug (fun m ->
          m
            "EMAIL: Sending email using mailgun failed with http status %i and \
             body %s"
            status
            body);
      Lwt.return @@ Error (`Internal_error "Failed to send email")

  let deliver_confirmation_instructions ~url user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Confirm your email"
      (Printf.sprintf
         {|
Hi %s,

You can confirm your account by visiting the url below:

%s

If you didn't create an account with us, please ignore this.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_reset_password_instructions ~url user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Reset your password"
      (Printf.sprintf
         {|
Hi %s,

You can reset your password by visiting the url below:

%s

If you didn't create an account with us, please ignore this.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_update_email_instructions ~url user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Confirm your email"
      (Printf.sprintf
         {|
Hi %s,

You can change your e-mail by visiting the url below:

%s

If you didn't create an account with us, please ignore this.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.username)
         url)

  let deliver_deleted_account_email user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Account deletion"
      (Printf.sprintf
         {|
Hi %s,

This email is to confirm that your account and all your datasets have been deleted from Sapiens_backend.

We're sorry to see you go. You can reach out to us at support@sapiens.com if you have any questions or would like to share feedback.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.username))
end
