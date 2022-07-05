import { Component, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Subject, takeUntil } from 'rxjs';
import { ModalProcessService } from '../modal-process/modal-process.service';

@Component({
  selector: 'app-container-modal-process',
  templateUrl: './container-modal-process.component.html',
})
export class ContainerModalProcessComponent implements OnDestroy {
  destroy = new Subject<any>();
  currentDialog: any;

  constructor(
    private _modalProcessService: ModalProcessService,
    private _router: Router,
    private _activatedRoute: ActivatedRoute,
    route: ActivatedRoute
  ) {
    route.params.pipe(takeUntil(this.destroy)).subscribe((params) => {
      this.currentDialog = this._modalProcessService
        .openModalProcess()
        .afterClosed()
        .subscribe(() => {
          /**
           * Navigate to parent route
           */
          let route = this._activatedRoute;
          while (route.firstChild) {
            route = route.firstChild;
          }
          this._router.navigate(['../'], { relativeTo: route });
        });
    });
  }

  ngOnDestroy() {
    this.destroy.next(0);
  }
}
