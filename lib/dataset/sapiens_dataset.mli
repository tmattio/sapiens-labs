module type Dataset = Dataset_intf.S

val datasets : (module Dataset) list

val create_dataset
  :  (module Dataset)
  -> ( unit
     , [> `Already_exists
       | `Internal_error of string
       | `Permission_denied
       | `Not_found
       | `Validation_error of string
       ] )
     result
     Lwt.t
