import type { HttpContext } from '@adonisjs/core/http'
import logger from '@adonisjs/core/services/logger'
import Objet from '#models/objet'

export default class ObjetsController {
  /**
   * Display a list of resource
   */
  async getAll({ response }: HttpContext) {
    try {
      const objets: Objet[] = await Objet.all()

      return response.status(200).send(objets)
    } catch (err) {
      logger.error({ err: err }, 'Erreur de recuperation des objets')
      return response.status(500).send('Erreur serveur')
    }
  }

  /**
   * Handle form submission for the create action
   */
  async getById({ request }: HttpContext) {}
  /**
   * Display form to create a new record
   */
  async create({}: HttpContext) {}

  /**
   * Edit individual record
   */
  async modify({ params }: HttpContext) {}

  /**
   * Delete record
   */
  async delete({ params }: HttpContext) {}
}
