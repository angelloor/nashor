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
import { processType } from '../../process-type/process-type.data';
import { ProcessTypeService } from '../../process-type/process-type.service';
import { ProcessType } from '../../process-type/process-type.types';
import { FlowVersionService } from '../flow-version/flow-version.service';
import { FlowVersion } from '../flow-version/flow-version.types';
import { FlowService } from '../flow.service';
import { Flow } from '../flow.types';
import { FlowListComponent } from '../list/list.component';
import { ModalFlowVersionService } from '../modal-flow-version/modal-flow-version.service';

@Component({
  selector: 'flow-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class FlowDetailsComponent implements OnInit {
  listProcessType: ProcessType[] = [];
  selectedProcessType: ProcessType = processType;
  flowVersions!: FlowVersion[];

  nameEntity: string = 'Flujo';
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
  flow!: Flow;
  flowForm!: FormGroup;
  private flows!: Flow[];

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
    private _flowListComponent: FlowListComponent,
    private _flowService: FlowService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _processTypeService: ProcessTypeService,
    private _modalFlowVersionService: ModalFlowVersionService,
    private _flowVersionService: FlowVersionService
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
    this._flowListComponent.matDrawer.open();
    /**
     * Create the flow form
     */
    this.flowForm = this._formBuilder.group({
      id_flow: [''],
      id_company: ['', [Validators.required]],
      id_process_type: ['', [Validators.required]],
      name_flow: ['', [Validators.required, Validators.maxLength(100)]],
      description_flow: ['', [Validators.required, Validators.maxLength(250)]],
    });
    /**
     * Get the flows
     */
    this._flowService.flows$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((flows: Flow[]) => {
        this.flows = flows;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the flow
     */
    this._flowService.flow$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((flow: Flow) => {
        /**
         * Open the drawer in case it is closed
         */
        this._flowListComponent.matDrawer.open();
        /**
         * Get the flow
         */
        this.flow = flow;

        // ProcessType
        this._processTypeService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((process_types: ProcessType[]) => {
            this.listProcessType = process_types;

            this.selectedProcessType = this.listProcessType.find(
              (item) =>
                item.id_process_type ==
                this.flow.process_type.id_process_type.toString()
            )!;
          });

        this._flowVersionService
          .byFlowRead(this.flow.id_flow)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();

        this._flowVersionService.flowVersions$
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_flowVersions: FlowVersion[]) => {
            this.flowVersions = _flowVersions;
            /**
             * Disabled or enabled control
             */
            if (this.flowVersions.length > 0) {
              this.flowForm.get('id_process_type')?.disable();
            } else {
              this.flowForm.get('id_process_type')?.enable();
            }
          });
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
    this.flowForm.patchValue({
      ...this.flow,
      id_company: this.flow.company.id_company,
      id_process_type: this.flow.process_type.id_process_type,
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
    return this._flowListComponent.matDrawer.close();
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
   * Update the flow
   */
  updateFlow(): void {
    /**
     * Get the flow
     */
    const id_user_ = this.data.user.id_user;
    let flow = this.flowForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    flow = {
      ...flow,
      id_user_: parseInt(id_user_),
      id_flow: parseInt(flow.id_flow),
      company: {
        id_company: parseInt(flow.id_company),
      },
      process_type: {
        id_process_type: parseInt(flow.id_process_type),
      },
    };
    /**
     * Update
     */
    this._flowService
      .update(flow)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flow: Flow) => {
          console.log(_flow);
          if (_flow) {
            this._notificationService.success(
              'Flujo actualizada correctamente'
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
   * Delete the flow
   */
  deleteFlow(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar flujo',
        message:
          '¿Estás seguro de que deseas eliminar esta flujo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current flow's id
           */
          const id_user_ = this.data.user.id_user;
          const id_flow = this.flow.id_flow;
          /**
           * Get the next/previous flow's id
           */
          const currentIndex = this.flows.findIndex(
            (item) => item.id_flow === id_flow
          );

          const nextIndex =
            currentIndex + (currentIndex === this.flows.length - 1 ? -1 : 1);
          const nextId =
            this.flows.length === 1 && this.flows[0].id_flow === id_flow
              ? null
              : this.flows[nextIndex].id_flow;
          /**
           * Delete
           */
          this._flowService
            .delete(id_user_, id_flow)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                console.log(response);
                if (response) {
                  /**
                   * Return if the flow wasn't deleted...
                   */
                  this._notificationService.success(
                    'Flujo eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next flow if available
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
  /**
   * openModalVersion
   */
  openModalVersion(): void {
    const id_flow = this.flow.id_flow;
    this._modalFlowVersionService.openModalFlowVersion(id_flow);
  }
}
