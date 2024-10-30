(* For simplicity, this module simply logs messages to the terminal.

   You should replace it by a proper e-mail or notification tool. *)

module type S = sig
  val deliver_invitation_instructions
    :  url:string
    -> inviter:Account_user.t
    -> dataset:Dataset_dataset.t
    -> Account_user.t
    -> ( Account_user.Email.t * string
       , [> `Internal_error of string ] )
       Lwt_result.t

  val deliver_transfer_instructions
    :  url:string
    -> inviter:Account_user.t
    -> dataset:Dataset_dataset.t
    -> Account_user.t
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

  let deliver_invitation_instructions ~url ~inviter ~dataset user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|

    ==============================

    Hi %s,

    %s has invited you to collaborate on the %s dataset.
    
    You can accept this invitation by visiting the url below:
    
    %s
    
    This invitation will expire in 7 days.
    
    This invitation was intended for %s. If you were not expecting this invitation, you can ignore this email.

    ==============================
|}
         (Account_user.Username.to_string user.Account_user.username)
         (Account_user.Username.to_string inviter.Account_user.username)
         (Dataset_dataset.Name.to_string dataset.Dataset_dataset.name)
         url
         (Account_user.Email.to_string user.Account_user.email))

  let deliver_transfer_instructions ~url ~inviter ~dataset user =
    deliver
      user.Account_user.email
      (Printf.sprintf
         {|

    ==============================

    Hi %s,

    %s has requested to transfer his dataset %s to your account.
    
    You can accept this transfer invitation by visiting the url below:
    
    %s
    
    This invitation will expire in 7 days.
    
    This invitation was intended for %s. If you were not expecting this invitation, you can ignore this email.
    
    Thanks,
    The Sapiens Team.

    ==============================
|}
         (Account_user.Username.to_string user.Account_user.username)
         (Account_user.Username.to_string inviter.Account_user.username)
         (Dataset_dataset.Name.to_string dataset.Dataset_dataset.name)
         url
         (Account_user.Email.to_string user.Account_user.email))
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

  let deliver_invitation_instructions ~url ~inviter ~dataset user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Confirm your email"
      (Printf.sprintf
         {|
Hi %s,

%s has invited you to collaborate on the %s dataset.

You can accept this invitation by visiting the url below:

%s

This invitation will expire in 7 days.

This invitation was intended for %s. If you were not expecting this invitation, you can ignore this email.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.Account_user.username)
         (Account_user.Username.to_string inviter.Account_user.username)
         (Dataset_dataset.Name.to_string dataset.Dataset_dataset.name)
         url
         (Account_user.Email.to_string user.Account_user.email))

  let deliver_transfer_instructions ~url ~inviter ~dataset user =
    deliver
      ~email:user.Account_user.email
      ~subject:"Confirm your email"
      (Printf.sprintf
         {|
Hi %s,

%s has requested to transfer his dataset %s to your account.

You can accept this transfer invitation by visiting the url below:

%s

This invitation will expire in 7 days.

This invitation was intended for %s. If you were not expecting this invitation, you can ignore this email.

Thanks,
The Sapiens Team.
|}
         (Account_user.Username.to_string user.Account_user.username)
         (Account_user.Username.to_string inviter.Account_user.username)
         (Dataset_dataset.Name.to_string dataset.Dataset_dataset.name)
         url
         (Account_user.Email.to_string user.Account_user.email))
end
