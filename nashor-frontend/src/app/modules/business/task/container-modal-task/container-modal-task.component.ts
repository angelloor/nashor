// import { Component, OnDestroy } from '@angular/core';
// import { ActivatedRoute, Router } from '@angular/router';
// import { Subject, takeUntil } from 'rxjs';
// import { ModalTaskService } from '../modal-task/modal-task.service';

// @Component({
//   selector: 'app-container-modal-task',
//   templateUrl: './container-modal-task.component.html',
// })
// export class ContainerModalTaskComponent implements OnDestroy {
//   destroy = new Subject<any>();
//   currentDialog: any;

//   constructor(
//     private _modalTaskService: ModalTaskService,
//     private _router: Router,
//     private _activatedRoute: ActivatedRoute,
//     route: ActivatedRoute
//   ) {
//     route.params.pipe(takeUntil(this.destroy)).subscribe((params) => {
//       this.currentDialog = this._modalTaskService
//         .openModalTask()
//         .afterClosed()
//         .subscribe(() => {
//           /**
//            * Navigate to parent route
//            */
//           let route = this._activatedRoute;
//           while (route.firstChild) {
//             route = route.firstChild;
//           }
//           this._router.navigate(['../'], { relativeTo: route });
//         });
//     });
//   }

//   ngOnDestroy() {
//     this.destroy.next(0);
//   }
// }
