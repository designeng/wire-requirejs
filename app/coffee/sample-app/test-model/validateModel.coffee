define ->
    
    validateModel = (contact) ->
        valid = undefined
        result = undefined
        result =
            valid: true
            errors: []

        valid = contact and 'firstName' of contact and contact.firstName.trim()
        unless valid
            result.valid = false
            result.errors.push
                property: 'firstName'
                message: 'missing'

        # valid = contact and 'lastName' of contact and contact.lastName.trim()
        # unless valid
        #     result.valid = false
        #     result.errors.push
        #         property: 'lastName'
        #         message: 'missing'

        console.log "result----->", result
        result
