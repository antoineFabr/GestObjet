import type { HttpContext } from '@adonisjs/core/http'
import Type from '#models/type'
import logger from '@adonisjs/core/services/logger'

export default class TypesController {
  
  async getAll({ response }: HttpContext) {
    try {
      const types = await Type.find()

      return response.status(200).send(types)
    } catch (err) {
      logger.error({ err: err }, 'Erreur de recuperation des types')
      return response.status(500).send('Erreur serveur')
    }
  }
  async create({request, response}: HttpContext) {
    try {
      const payload = request.body()
       const existType = await Type.findOne({
        libelle: payload.libelle
      })
      if(existType) {
        return response.status(400).json({
          message: "Type déjà existant"
        })
      }

      const newType = await Type.create({
        libelle: payload.libelle
      })

      return response.status(200).send("Type créer avec succès")
    } catch (err) {
      console.error(err) 
      return response.status(500).send("Erreur de création de type")
    }
  }
  
 
}