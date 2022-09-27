import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { company } from 'app/modules/core/company/company.data';
import { CompanyService } from 'app/modules/core/company/company.service';
import { Company } from 'app/modules/core/company/company.types';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { PluginItemListComponent } from '../list/list.component';
import { PluginItemColumnService } from '../plugin-item-column/plugin-item-column.service';
import { PluginItemColumn } from '../plugin-item-column/plugin-item-column.types';
import { PluginItemService } from '../plugin-item.service';
import { PluginItem } from '../plugin-item.types';

@Component({
  selector: 'plugin-item-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class PluginItemDetailsComponent implements OnInit {
  listCompany: Company[] = [];
  selectedCompany: Company = company;

  nameEntity: string = 'Plugin Item';
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
  pluginItem!: PluginItem;
  pluginItemForm!: FormGroup;
  private pluginItems!: PluginItem[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  pluginItemColumn: PluginItemColumn[] = [];

  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _pluginItemListComponent: PluginItemListComponent,
    private _pluginItemService: PluginItemService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _companyService: CompanyService,
    private _pluginItemColumnService: PluginItemColumnService
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
    this._pluginItemListComponent.matDrawer.open();
    /**
     * Create the pluginItem form
     */
    this.pluginItemForm = this._formBuilder.group({
      id_plugin_item: [''],
      id_company: ['', [Validators.required]],
      name_plugin_item: ['', [Validators.required, Validators.maxLength(100)]],
      description_plugin_item: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      select_plugin_item: ['', [Validators.required]],
      columns: this._formBuilder.array([]),
    });
    /**
     * Get the pluginItems
     */
    this._pluginItemService.pluginItems$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((pluginItems: PluginItem[]) => {
        this.pluginItems = pluginItems;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the pluginItem
     */
    this._pluginItemService.pluginItem$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((pluginItem: PluginItem) => {
        /**
         * Open the drawer in case it is closed
         */
        this._pluginItemListComponent.matDrawer.open();
        /**
         * Get the pluginItem
         */
        this.pluginItem = pluginItem;

        // Company
        this._companyService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((companys: Company[]) => {
            this.listCompany = companys;

            this.selectedCompany = this.listCompany.find(
              (item) =>
                item.id_company == this.pluginItem.company.id_company.toString()
            )!;
          });

        this._pluginItemColumnService
          .byPluginItemQueryRead(this.pluginItem.id_plugin_item, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe(() => {
            /**
             *Subscribe to pluginItemColumns
             */
            this._pluginItemColumnService.pluginItemColumns$
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe((pluginItemColumn: PluginItemColumn[]) => {
                this.pluginItemColumn = pluginItemColumn;

                /**
                 * Clear the columns form arrays
                 */
                (this.pluginItemForm.get('columns') as FormArray).clear();

                const columnsFormGroups: any = [];

                /**
                 * Iterate through them
                 */
                this.pluginItemColumn.forEach((_column, index: number) => {
                  /**
                   * Create an column form group
                   */
                  columnsFormGroups.push(
                    this._formBuilder.group({
                      id_plugin_item_column: [_column.id_plugin_item_column],
                      plugin_item: [_column.plugin_item],
                      name_plugin_item_column: [
                        _column.name_plugin_item_column,
                      ],
                      lenght_plugin_item_column: [
                        _column.lenght_plugin_item_column,
                      ],
                    })
                  );
                });

                /**
                 * Add the columns form groups to the columns form array
                 */
                columnsFormGroups.forEach((columnsFormGroup: any) => {
                  (this.pluginItemForm.get('columns') as FormArray).push(
                    columnsFormGroup
                  );
                });
              });
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

  get formArrayColumns(): FormArray {
    return this.pluginItemForm.get('columns') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.pluginItemForm.patchValue({
      ...this.pluginItem,
      id_company: this.pluginItem.company.id_company,
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
    return this._pluginItemListComponent.matDrawer.close();
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
   * createPluginItemColumn
   */
  createPluginItemColumn(): void {
    this._angelConfirmationService
      .open({
        title: 'Añadir item plugin column',
        message:
          '¿Estás seguro de que deseas añadir una nueva item plugin column? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          /**
           * Create the plugin_item_column
           */
          this._pluginItemColumnService
            .create(id_user_, this.pluginItem.id_plugin_item)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_pluginItemColumn: PluginItemColumn) => {
                if (_pluginItemColumn) {
                  this._notificationService.success(
                    'Item Plugin Column agregada correctamente'
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
   * Update the pluginItemColumn
   */
  updatePluginItemColumn(index: number): void {
    /**
     * Get the pluginItemColumn
     */
    const id_user_ = this.data.user.id_user;
    const columnsFormArray = this.pluginItemForm.get('columns') as FormArray;
    let pluginItemColumn = columnsFormArray.getRawValue()[index];

    /**
     * Delete whitespace (trim() the atributes type string)
     */
    pluginItemColumn = {
      ...pluginItemColumn,
      id_user_: parseInt(id_user_),
      lenght_plugin_item_column: parseInt(
        pluginItemColumn.lenght_plugin_item_column
      ),
      id_plugin_item_column: parseInt(pluginItemColumn.id_plugin_item_column),
      plugin_item: {
        id_plugin_item: parseInt(pluginItemColumn.plugin_item.id_plugin_item),
      },
    };

    /**
     * Update
     */
    this._pluginItemColumnService
      .update(pluginItemColumn)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_pluginItemColumn: PluginItemColumn) => {
          if (_pluginItemColumn) {
            this._notificationService.success(
              'Item Plugin Column actualizada correctamente'
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
  /**
   * Delete the pluginItemColumn
   */
  deletePluginItemColumn(index: number): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar item plugin column',
        message:
          '¿Estás seguro de que deseas eliminar esta item plugin column? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Delete
           */
          const id_user = this.data.user.id_user;

          const columnsFormArray = this.pluginItemForm.get(
            'columns'
          ) as FormArray;

          const id_plugin_item_column =
            columnsFormArray.getRawValue()[index].id_plugin_item_column;

          this._pluginItemColumnService
            .delete(id_user, id_plugin_item_column)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the pluginItemColumn wasn't deleted...
                   */
                  this._notificationService.success(
                    'Item Plugin Column eliminada correctamente'
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
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * Update the pluginItem
   */
  updatePluginItem(): void {
    /**
     * Get the pluginItem
     */
    const id_user_ = this.data.user.id_user;
    let pluginItem = this.pluginItemForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    pluginItem = {
      ...pluginItem,
      id_user_: parseInt(id_user_),
      id_plugin_item: parseInt(pluginItem.id_plugin_item),
      company: {
        id_company: parseInt(pluginItem.id_company),
      },
    };
    /**
     * Update
     */
    this._pluginItemService
      .update(pluginItem)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_pluginItem: PluginItem) => {
          if (_pluginItem) {
            this._notificationService.success(
              'Plugin Item actualizada correctamente'
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
   * Delete the pluginItem
   */
  deletePluginItem(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar item plugin',
        message:
          '¿Estás seguro de que deseas eliminar esta item plugin? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current pluginItem's id
           */
          const id_user_ = this.data.user.id_user;
          const id_plugin_item = this.pluginItem.id_plugin_item;
          /**
           * Get the next/previous pluginItem's id
           */
          const currentIndex = this.pluginItems.findIndex(
            (item) => item.id_plugin_item === id_plugin_item
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.pluginItems.length - 1 ? -1 : 1);
          const nextId =
            this.pluginItems.length === 1 &&
            this.pluginItems[0].id_plugin_item === id_plugin_item
              ? null
              : this.pluginItems[nextIndex].id_plugin_item;
          /**
           * Delete
           */
          this._pluginItemService
            .delete(id_user_, id_plugin_item)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the pluginItem wasn't deleted...
                   */
                  this._notificationService.success(
                    'Plugin Item eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next pluginItem if available
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
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
