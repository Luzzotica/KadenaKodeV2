(interface multisig-v1

  (defschema signature
    @doc "A Pact API Signature"
    pubKey:string
    sig:string
  )

  (defschema multisig-pact-command
    @doc "Stores the Pact Commands in a table with the list of signers, \
    \ the record id should be the hash of the command."
    cmd:string
    sigs:[object{signature}]
    hash:string
    signers:[string]
    guard:guard
    resolved:bool
  )

  (defcap CAN_MODIFY:string
    (
      hash:string
    )
    @doc "A capability to check if the guard of a multisig-pact-command is satisfied."
  )

  (defun create-multisig-pact-command:string
    (
      cmd:string
      signers:[string]
      signatures:[object{signature}]
      guard:guard
    )
    @doc "Create a multsig pact command record"
  )

  (defun add-signer:string
    (
      hash:string
      signature:object{signature}
    )
    @doc "Add a signature to a multsig pact command record"
  )

  (defun set-resolved:string
    (
      hash:string
      resolved:bool
    )  
    @doc "Mark a multsig pact command record as the given resolved value"
  )

  (defun get-multisig-pact-command:object{multisig-pact-command}
    (
      hash:string
    )
    @doc "Get a multsig pact command record"  
  )

  (defun get-multisig-pact-commands-by-signer:[object{multisig-pact-command}]
    (
      signer:string
    )
    @doc "Get a list of multsig pact command records by signer (pubKey)"  
  )
)



  

  ;  (defschema pact-command
  ;    @doc "A Pact API Pact Command"
  ;    cmd:string
  ;    sigs:[object{signature}]
  ;    hash:string  
  ;  )