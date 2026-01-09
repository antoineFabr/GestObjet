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
  
}