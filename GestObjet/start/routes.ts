/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
import SallesController from '#controllers/salles_controller'

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

router
  .group(() => {
    router
      .group(() => {
        router.get('/', [SallesController, 'getAll'])
        router.get('/:id', [SallesController, 'getById'])
        router.post('/', [SallesController, 'create'])
        router.put('/:id', [SallesController, 'modify'])
        router.delete('/:id', [SallesController, 'delete'])
      })
      .prefix('salle')
  })
  .prefix('api')
