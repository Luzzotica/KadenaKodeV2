(module kadena-multisig GOV

  ;; -------------------------------
  ;; Governance and Permissions

  (defconst GOV_GUARD:string "gov")

  (defcap GOV ()
    (enforce-guard (at "guard" (read m-guards GOV_GUARD ["guard"])))
  )

  (defschema m-guard ;; ID is a const: OPS_GUARD, GOV_GUARD etc.
    @doc "Stores guards for the module"
    guard:guard
  )
  (deftable m-guards:{m-guard})

  (defun rotate-gov:string (guard:guard)
    @doc "Requires GOV. Changes the gov guard to the provided one."

    (with-capability (GOV)
      (update m-guards GOV_GUARD
        { "guard": guard }  
      )

      "Rotated GOV to a new guard"
    )
  )

  (defun get-gov-guard:guard ()
    @doc "Gets the current gov guard and returns it"
    (at "guard" (read m-guards GOV_GUARD))
  )

  (defun init-perms:string (gov:guard)
    @doc "Initializes the guards and creates the tables for the module"

    ;; This is only vulnerable if GOV_GUARD doesn't exist
    ;; Which means it's only vulnerable if you don't call 
    ;; init when you deploy the contract.
    ;; So let us be sure that init is called. =)
    (insert m-guards GOV_GUARD
      { "guard": gov }  
    )
  )

  ;; -------------------------------
  ;; Multisig Pact Command Storage

  (use multisig-v1 [signature multisig-pact-command])
  (implements multisig-v1)

  (deftable multisig-pact-commands:{multisig-pact-command})

  (defcap CAN_MODIFY:string (hash:string)  
    @doc "A capability to check if the guard of a multisig-pact-command is satisfied."
    (with-read multisig-pact-commands hash 
      { "guard":= guard }
      (enforce-guard guard)
    )
  )

  (defun create-multisig-pact-command:string
    (
      cmd:string
      signers:[string]
      signatures:[object{signature}]
      guard:guard
    )
    @doc "Create a multisig pact command record, signers is a list of public keys that need to sign the transaction."
    (let 
      (
        (hash (hash cmd))
      )
      (insert multisig-pact-commands hash
        { "cmd": cmd
        , "sigs": signatures
        , "hash": hash
        , "signers": signers
        , "guard": guard
        , "resolved": false
        }
      )
      hash
    )
  )

  (defun add-signer:string
    (
      hash:string
      signature:object{signature}
    )
    @doc "Add a signature to a multisig pact command record"
    (with-capability (CAN_MODIFY hash)
      (with-read multisig-pact-commands hash 
        { "sigs":= sigs
        , "resolved":= resolved }
        (enforce (not resolved) "Record is already marked as resolved")

        (update multisig-pact-commands hash {
          "sigs": (+ sigs [signature])
        })
        "Signature added"
      )
    )
  )

  (defun set-resolved:string
    (
      hash:string
      resolved:bool
    )
    @doc "Mark a multsig pact command record as the given resolved value"
    (with-capability (CAN_MODIFY hash)
      (update multisig-pact-commands hash 
        { "resolved": resolved }
      )
    )
    "Resolution status updated"
  )

  (defun get-multisig-pact-command:object{multisig-pact-command}
    (
      hash:string
    )
    @doc "Get a multisig pact command record"
    (read multisig-pact-commands hash)
  )

  (defun get-multisig-pact-commands-by-signer:[object{multisig-pact-command}]
    (
      signer:string
    )
    @doc "Get a list of multisig pact command records by signer (pubKey)"
    (filter 
      (lambda (row:object{multisig-pact-command})
        (contains signer (at "signers" row))
      )
      (select multisig-pact-commands (where "resolved" (= false)))
    )
  )
)

(if (read-msg "upgrade")
  "Contract upgraded"
  [
    (create-table m-guards)
    (create-table multisig-pact-commands)
    (init-perms (read-keyset "gov"))
  ]
)