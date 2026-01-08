import mongoose, { Schema, Document } from 'mongoose'
import "./type.js"
export interface IObjet extends Document {
  qrCode: string
  type: mongoose.Types.ObjectId // Référence vers le Type
  salles: mongoose.Types.ObjectId[] // Relation Many-to-Many (voir point C)
}

const ObjetSchema = new Schema(
  {
    qrCode: { type: String, required: true, unique: true },

    // Clé étrangère vers Type
    type: {
      type: Schema.Types.ObjectId,
      ref: 'Type', // Doit matcher le nom du modèle 'Type'
      required: true,
    },

    // Pour la relation ManyToMany avec Salle (on stocke un tableau d'IDs)
    salles: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Salle',
      },
    ],
  },
  {
    timestamps: true,
  }
)

export default mongoose.model<IObjet>('Objet', ObjetSchema)
