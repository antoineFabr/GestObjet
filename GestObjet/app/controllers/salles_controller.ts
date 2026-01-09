import type { HttpContext } from '@adonisjs/core/http'
import logger from '@adonisjs/core/services/logger'
import Salle from '#models/salle'
import { SalleValidator } from '#validators/salle'

export default class SallesController {
  /**
   * Display a list of resource
   */
  async getAll({ response }: HttpContext) {
    try {
      const salles = await Salle.find()
      return response.status(200).send(salles)
    } catch (err) {
      logger.error({ err: err }, 'Erreur de récuperation des salles')
      return response.status(500).send('Erreur serveur')
    }
  }

  async getById({ params, response }: HttpContext) {
    const id = decodeURIComponent(params.id)
    try {
      const salle = await Salle.findById(id)
      if (!salle) {
        return response.status(404).send('salle pas trouvé')
      }
      return response.status(200).send(salle)
    } catch (err) {
      logger.error({ err: err }, `erreur lors de la récuperation de la salle dont l'id est ${id}`)
      return response
        .status(500)
        .send(`erreur lors de la récuperation de la salle dont l'id est ${id}`)
    }
  }

  async getObjets({ params, response }: HttpContext) {
    const id = decodeURIComponent(params.id)
    try {
      const salle = await Salle.findById(id).populate({
        path: 'objets',
        populate: {
          path: 'type',
          select: 'libelle',
        },
      })
      if (!salle) {
        return response.notFound({ message: 'Salle non trouvée' })
      }
      return response.status(200).send(salle.objets)
    } catch (err) {
      logger.error({ err: err }, `erreur lors de la récuperation de la salle dont l'id est ${id}`)
      return response
        .status(500)
        .send(`erreur lors de la récuperation de la salle dont l'id est ${id}`)
    }
  }
  /**
   * Display form to create a new record
   */
  async create({ request, response }: HttpContext) {
    try {
      const payload = await request.validateUsing(SalleValidator)

      await Salle.create({
        numero: payload.numero,
        batiment: payload.batiment,
      })
      return response.status(200).send('Salle créé avec succès !')
    } catch (err) {
      logger.error({ err: err }, 'erreur de création de salle')
      return response.status(500).send('erreur de création de salle')
    }
  }

  /**
   * Edit individual record
   */
  async modify({ params, request, response }: HttpContext) {
    const id = params.id
    try {
      if (isNaN(Number(id))) {
        return response.status(404).send("l'id de la salle doit etre un nombre")
      }
      const payload = await request.validateUsing(SalleValidator)
      console.log(payload)
      const salle = await Salle.findByIdAndUpdate(id, payload, { new: true })
      if (!salle) {
        return response.status(404).send("la salle n'a pas été trouvé")
      }

      return response.status(200).send('la salle a bien été modifié')
    } catch (err) {
      logger.error({ err: err }, `erreur lors de la modification de la salle ${id}`)
      return response.status(500).send(`erreur lors de la modification de la salle ${id}`)
    }
  }

  /**
   * Delete record
   */
  async delete({ params, response }: HttpContext) {
    const id = params.id
    try {
      if (isNaN(Number(id))) {
        return response.status(404).send("l'id de la salle doit etre un nombre")
      }

      const salle = await Salle.findByIdAndDelete(id)
      if (!salle) {
        return response.status(404).send("la salle n'a pas été trouvé")
      }

      return response.status(200).send(`la salle ${id} a bien été supprimer !`)
    } catch (err) {
      logger.error({ err: err }, `Erreur lors de la suppression de la salle ${id}`)
      return response.status(500).send(`Erreur lors de la suppression de la salle ${id}`)
    }
  }
}
