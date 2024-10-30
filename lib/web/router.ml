open Opium

let router : Rock.Handler.t Router.t = Router.empty

let scope ?(route = "") ?(middlewares = []) router routes =
  ListLabels.fold_left
    routes
    ~init:router
    ~f:(fun router (meth, subroute, action) ->
      let filters =
        ListLabels.map ~f:(fun m -> m.Rock.Middleware.filter) middlewares
      in
      let service = Rock.Filter.apply_all filters action in
      Router.add
        router
        ~action:service
        ~meth
        ~route:(Route.of_string (route ^ subroute)))

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.require_authenticated_user
      ; User_auth_middleware.fetch_current_user
      ]
    ~route:"/datasets"
    [ `GET, "", Dataset_handler.index
    ; `GET, "/:id/export", Dataset_handler.export
    ; `GET, "/:id/tasks", Dataset_handler.show_tasks
    ; `POST, "/:id/tasks/complete", Dataset_handler.complete_task
    ; `POST, "/:id/tasks/cancel", Dataset_handler.cancel_task
    ; `GET, "/:id/tasks/new", Dataset_handler.new_task
    ; `POST, "/:id/tasks", Dataset_handler.create_task
    ; `GET, "/:id/insights", Dataset_handler.show_insights
    ; `GET, "/:id/settings", Dataset_handler.edit
    ; `GET, "/:id/settings/sources", Dataset_handler.edit_sources
    ; `GET, "/:id/settings/collaborators", Dataset_handler.edit_collaborators
    ; `GET, "/:id/upload", Dataset_handler.show_upload
    ; `POST, "/:id/upload", Dataset_handler.upload
    ; `GET, "/new", Dataset_handler.new_
    ; `GET, "/:id", Dataset_handler.show
    ; `POST, "", Dataset_handler.create
    ; `Other "PATCH", "/:id", Dataset_handler.update
    ; `PUT, "/:id", Dataset_handler.update
    ; `PUT, "/:id/invite", Dataset_handler.invite
    ; `GET, "/invite/:token", Dataset_handler.accept_invite
    ; `DELETE, "/:id", Dataset_handler.delete
    ; `DELETE, "/:id/removed_collaborator", Dataset_handler.remove_collaborator
    ]

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.require_authenticated_user
      ; User_auth_middleware.fetch_current_user
      ]
    ~route:"/models"
    [ `GET, "", Model_handler.index
    ; `GET, "/:id/settings", Model_handler.edit
    ; `GET, "/new", Model_handler.new_
    ; `GET, "/:id", Model_handler.show
    ; `POST, "", Model_handler.create
    ; `Other "PATCH", "/:id", Model_handler.update
    ; `PUT, "/:id", Model_handler.update
    ; `DELETE, "/:id", Model_handler.delete
    ]

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.require_authenticated_user
      ; User_auth_middleware.fetch_current_user
      ]
    ~route:"/tasks"
    [ `GET, "", Task_handler.index
    ; `GET, "/:id", Task_handler.show
    ; `POST, "/:id", Task_handler.update
    ]

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.require_authenticated_user
      ; User_auth_middleware.fetch_current_user
      ]
    ~route:""
    [ `GET, "/search", Search_handler.search ]

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.redirect_if_user_is_authenticated
      ; User_auth_middleware.fetch_current_user
      ]
    ~route:"/users"
    [ `GET, "/register", User_registration_handler.new_
    ; `POST, "/register", User_registration_handler.create
    ; `GET, "/login", User_session_handler.new_
    ; `POST, "/login", User_session_handler.create
    ; `GET, "/reset_password", User_reset_password_handler.new_
    ; `POST, "/reset_password", User_reset_password_handler.create
    ; `GET, "/reset_password/:token", User_reset_password_handler.edit
    ; `PUT, "/reset_password/:token", User_reset_password_handler.update
    ]

let router =
  scope
    router
    ~middlewares:
      [ User_auth_middleware.require_authenticated_user
      ; User_auth_middleware.fetch_current_user
      ]
    [ `DELETE, "/users/logout", User_session_handler.delete
    ; `GET, "/users/settings", User_settings_handler.edit
    ; ( `PUT
      , "/users/settings/updated_password"
      , User_settings_handler.update_password )
    ; `PUT, "/users/settings/updated_email", User_settings_handler.update_email
    ; ( `DELETE
      , "/users/settings/deleted_account"
      , User_settings_handler.delete_account )
    ; ( `PUT
      , "/users/settings/confirm_email/:token"
      , User_settings_handler.confirm_email )
    ]

let router =
  scope
    router
    ~middlewares:[ User_auth_middleware.fetch_current_user ]
    [ `GET, "/", Page_handler.index
    ; `GET, "/about", Page_handler.about
    ; `GET, "/jobs", Page_handler.jobs
    ; `GET, "/features/analytics", Page_handler.features_analytics
    ; `GET, "/features/annotation", Page_handler.features_annotation
    ; `GET, "/features/model-training", Page_handler.features_model_training
    ; `GET, "/features/model-deployment", Page_handler.features_model_deployment
    ; `GET, "/pricing", Page_handler.pricing
    ; `GET, "/consulting", Page_handler.consulting
    ; `GET, "/terms", Page_handler.terms
    ; `GET, "/privacy", Page_handler.privacy
    ]

let router =
  scope
    router
    ~middlewares:[]
    [ `GET, "/users/confirm", User_confirmation_handler.new_
    ; `POST, "/users/confirm", User_confirmation_handler.create
    ; `GET, "/users/confirm/:token", User_confirmation_handler.confirm
    ]
