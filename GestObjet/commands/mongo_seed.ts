import { BaseCommand } from '@adonisjs/core/ace'
import type { CommandOptions } from '@adonisjs/core/types/ace'
import Type from '#models/type'
import Salle from '#models/salle'
import Objet from '#models/objet'

export default class MongoSeed extends BaseCommand {
  static commandName = 'mongo:seed'
  static description = 'Remplir la base MongoDB avec des données de test'

  static options: CommandOptions = {
    startApp: true, // Très important : permet de charger la connexion Mongoose définie dans start/
  }

  async run() {
    this.logger.info('🌱 Démarrage du Seeding MongoDB...')

    // 1. Nettoyer la base (Optionnel : supprime tout avant de recréer)
    await Type.deleteMany({})
    await Salle.deleteMany({})
    await Objet.deleteMany({})
    this.logger.info('🧹 Base nettoyée')

    // 2. Créer des Types
    const typeInfo = await Type.create({ libelle: 'Informatique' })
    const typeMeuble = await Type.create({ libelle: 'Mobilier' })
    this.logger.success('✅ Types créés')

    // 3. Créer des Objets (On utilise les IDs des types créés)
    const pc1 = await Objet.create({ qrCode: 'PC-001', type: typeInfo._id })
    const pc2 = await Objet.create({ qrCode: 'PC-002', type: typeInfo._id })
    const chaise = await Objet.create({ qrCode: 'CH-001', type: typeMeuble._id })
    this.logger.success('✅ Objets créés')

    // 4. Créer des Salles et leur associer des objets
    await Salle.create({
      numero: '101',
      batiment: 'A',
      objets: [pc1._id, chaise._id], // On met les IDs directement
    })

    await Salle.create({
      numero: '102',
      batiment: 'B',
      objets: [pc2._id],
    })
    await Salle.create({
      numero: '103',
      batiment: 'B',
      objets: [],
    })
    await Salle.create({
      numero: '104',
      batiment: 'B',
      objets: [],
    })
    await Salle.create({
      numero: '105',
      batiment: 'B',
      objets: [],
    })
    this.logger.success('✅ Salles créées')

    this.logger.info('🚀 Seeding terminé avec succès !')
  }
}
