import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { AuthService } from 'app/core/auth/auth.service';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Observable, Subject } from 'rxjs';
import { switchMap, takeUntil } from 'rxjs/operators';
import { AttachedService } from '../attached.service';
import { Attached } from '../attached.types';
import { ModalAttachedService } from '../modal-attached/modal-attached.service';
import { ModalAttachedsService } from './modal-attacheds.service';

@Component({
  selector: 'app-modal-attacheds',
  templateUrl: './modal-attacheds.component.html',
  styleUrls: ['./modal-attacheds.component.scss'],
})
export class ModalAttachedsComponent implements OnInit {
  count: number = 0;
  attacheds$!: Observable<Attached[]>;
  id_company: string = '';

  private data!: AppInitialData;

  searchInputControl: FormControl = new FormControl();
  selectedAttached!: Attached;

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _attachedService: AttachedService,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _authService: AuthService,
    private _modalAttachedsService: ModalAttachedsService,
    private _modalAttachedService: ModalAttachedService
  ) {}

  ngOnInit(): void {
    /**
     * checkSession
     */
    this._authService
      .checkSession()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * checkSession
     */
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Get the attacheds
     */
    this.attacheds$ = this._attachedService.attacheds$;
    /**
     *  byCompanyQueryRead *
     */
    this._attachedService
      .byCompanyQueryRead(this.id_company, '*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((attacheds: Attached[]) => {
        /**
         * Update the counts
         */
        this.count = attacheds.length;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     *  Count Subscribe
     */
    this._attachedService.attacheds$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((attacheds: Attached[]) => {
        /**
         * Update the counts
         */
        this.count = attacheds.length;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Subscribe to search input field value changes
     */
    this.searchInputControl.valueChanges
      .pipe(
        takeUntil(this._unsubscribeAll),
        switchMap((query) => {
          /**
           * Search
           */
          return this._attachedService.byCompanyQueryRead(
            this.id_company,
            query.toLowerCase()
          );
        })
      )
      .subscribe();
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
   /** ----------------------------------------------------------------------------------------------------- */
  /**
   * createAttached
   */
  createAttached(): void {
    this._angelConfirmationService
      .open({
        title: 'Añadir anexo',
        message:
          '¿Estás seguro de que deseas añadir una nueva anexo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          const id_company = this.data.user.company.id_company;
          /**
           * Create the attached
           */
          this._attachedService
            .create(id_user_, id_company)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_attached: Attached) => {
                if (_attached) {
                  this._notificationService.success(
                    'Anexo agregada correctamente'
                  );
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
  /**
   * closeModalAttacheds
   */
  closeModalAttacheds(): void {
    this._modalAttachedsService.closeModalAttacheds();
  }
  /**
   * openModalAttached
   */
  openModalAttached(id_attached: string): void {
    this._modalAttachedService.openModalAttached(id_attached);
  }
}
