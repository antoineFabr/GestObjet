import type { HttpContext } from '@adonisjs/core/http'
import Objet from '#models/objet'

export default class VerifiesController {
  /**
   * Display a list of resource
   */
  async verify({params, response}: HttpContext) {
    const id = decodeURIComponent(params.id)
        try {
          const objet = await Objet.findOne({
            _id: id
          }).populate({
            path: 'type',
            select: 'libelle'
          })
          return response.status(200).json(objet);
        } catch(e) {
          console.error(e) 
          return response.status(500).send("Erreur lors de la récuperation d'un objet via son qrCode")
        }
  }

  /**
   * Display form to create a new record
   */
  async create({}: HttpContext) {}

  /**
   * Handle form submission for the create action
   */
  async store({ request }: HttpContext) {}

  /**
   * Show individual record
   */
  async show({ params }: HttpContext) {}

  /**
   * Edit individual record
   */
  async edit({ params }: HttpContext) {}
  /**
   * Delete record
   */
  async destroy({ params }: HttpContext) {}
}