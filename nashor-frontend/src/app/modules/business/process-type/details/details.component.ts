import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { ProcessTypeListComponent } from '../list/list.component';
import { ProcessTypeService } from '../process-type.service';
import { ProcessType } from '../process-type.types';

@Component({
  selector: 'process-type-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class ProcessTypeDetailsComponent implements OnInit {
  nameEntity: string = 'Tipo de proceso';
  private data!: AppInitialData;

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  processType!: ProcessType;
  processTypeForm!: FormGroup;
  private processTypes!: ProcessType[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _processTypeListComponent: ProcessTypeListComponent,
    private _processTypeService: ProcessTypeService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
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
    });
    /**
     * Open the drawer
     */
    this._processTypeListComponent.matDrawer.open();
    /**
     * Create the processType form
     */
    this.processTypeForm = this._formBuilder.group({
      id_process_type: [''],
      id_company: [''],
      name_process_type: ['', [Validators.required, Validators.maxLength(100)]],
      description_process_type: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      acronym_process_type: [
        '',
        [Validators.required, Validators.maxLength(20)],
      ],
      sequential_process_type: [
        '',
        [Validators.required, Validators.maxLength(10)],
      ],
    });
    /**
     * Get the processTypes
     */
    this._processTypeService.processTypes$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((processTypes: ProcessType[]) => {
        this.processTypes = processTypes;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the processType
     */
    this._processTypeService.processType$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((processType: ProcessType) => {
        /**
         * Open the drawer in case it is closed
         */
        this._processTypeListComponent.matDrawer.open();
        /**
         * Get the processType
         */
        this.processType = processType;

        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        console.log(keyUpOrKeyDown);
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.processTypeForm.patchValue({
      ...this.processType,
      id_company: this.processType.company.id_company,
    });
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
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._processTypeListComponent.matDrawer.close();
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the processType
   */
  updateProcessType(): void {
    /**
     * Get the processType
     */
    const id_user_ = this.data.user.id_user;
    let processType = this.processTypeForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    processType = {
      ...processType,
      id_user_: parseInt(id_user_),
      id_process_type: parseInt(processType.id_process_type),
      company: {
        id_company: parseInt(processType.id_company),
      },
      sequential_process_type: parseInt(processType.sequential_process_type),
    };
    /**
     * Update
     */
    this._processTypeService
      .update(processType)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processType: ProcessType) => {
          console.log(_processType);
          if (_processType) {
            this._notificationService.success(
              'Tipo de proceso actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          console.log(error);
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
  /**
   * Delete the processType
   */
  deleteProcessType(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar tipo de proceso',
        message:
          '¿Estás seguro de que deseas eliminar esta tipo de proceso? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current processType's id
           */
          const id_user_ = this.data.user.id_user;
          const id_process_type = this.processType.id_process_type;
          /**
           * Get the next/previous processType's id
           */
          const currentIndex = this.processTypes.findIndex(
            (item) => item.id_process_type === id_process_type
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.processTypes.length - 1 ? -1 : 1);
          const nextId =
            this.processTypes.length === 1 &&
            this.processTypes[0].id_process_type === id_process_type
              ? null
              : this.processTypes[nextIndex].id_process_type;
          /**
           * Delete
           */
          this._processTypeService
            .delete(id_user_, id_process_type)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                console.log(response);
                if (response) {
                  /**
                   * Return if the processType wasn't deleted...
                   */
                  this._notificationService.success(
                    'Tipo de proceso eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next processType if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                console.log(error);
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
}
