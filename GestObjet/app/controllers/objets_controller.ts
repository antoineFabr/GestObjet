import type { HttpContext } from '@adonisjs/core/http'
import logger from '@adonisjs/core/services/logger'
import Objet from '#models/objet'
import Salle from '#models/salle'

export default class ObjetsController {
  /**
   * Display a list of resource
   */
  async getAll({ response }: HttpContext) {
    try {
      const objets = await Objet.find()

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

  async create({ request, response }: HttpContext) {
    try {
      const payload = request.body()
      const existObjet = await Objet.find({
        qrCode: payload.qrCode
      })
      if(existObjet) {
        return response.status(400).json({
          message: "Objet déjà existant"
        })
      }
      const newObjet = await Objet.create({
        qrCode: payload.qrCode,
        type: payload.type,
        salles: payload.salles || [], // On s'assure que c'est un tableau
      })
      if (payload.salles && payload.salles.length > 0) {
        await Salle.updateMany(
          { _id: { $in: payload.salles } },
          { $push: { objets: newObjet._id } }
        )
      }

      return response.status(200).json({
        message: 'Objet créé avec succès et lié aux salles !',
        data: newObjet,
      })
    } catch (err) {
      console.error(err) // Pour le debug rapide
      return response.status(500).send("Erreur de création d'objet")
    }
  }

  /**
   * Edit individual record
   */
  async modify({ params }: HttpContext) {}

  /**
   * Delete record
   */
  async delete({ params, response }: HttpContext) {
    const id = decodeURIComponent(params.id)
    try {
      await Objet.deleteOne({
        _id: id
      })
      return response.status(200).json({
        message: 'Objet supprimer avec succès!'        
      })
    } catch(e) {
      console.error(e) 
      return response.status(500).send("Erreur de suppression d'objet")
    }

  }
}
